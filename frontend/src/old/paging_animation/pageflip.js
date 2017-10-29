import Common from '../../base/common';

export default class PageFlip {
  static initClass() {

    this.DIRECTION = {};
    this.DIRECTION.FORWARD = 1;
    this.DIRECTION.BACK = 2;
  }

  // コンストラクタ
  // @param [Integer] beforePageNum 変更前ページ番号
  // @param [Integer] afterPageNum 変更後ページ番号
  constructor(beforePageNum, afterPageNum) {
    // Dimensions of one page in the book
    this.PAGE_WIDTH = $('#pages').width();
    this.PAGE_HEIGHT = $('#pages').height();

    // The canvas size equals to the book dimensions + this padding
    this.CANVAS_PADDING = 20;

    this.flipPageNum = beforePageNum < afterPageNum ? beforePageNum : afterPageNum;
    if(window.debug) {
      console.log(`[PageFlip constructor] flipPageNum:${this.flipPageNum}`);
    }

    this.zIndex = Common.plusPagingZindex(0, this.flipPageNum);

    // アニメーション用Div作成
    const zIndexMax = Common.plusPagingZindex(0, 0);
    $(`#${constant.Paging.ROOT_ID}`).append(`<div id='pageflip-root' style='position:absolute;top:0;left:0;width:100%;height:100%;z-index:${zIndexMax}'><canvas id='pageflip-canvas' style='z-index:${zIndexMax}'></canvas></div>`);

    this.canvas = document.getElementById("pageflip-canvas");
    this.context = this.canvas.getContext("2d");

    // Resize the canvas to match the book size
    this.canvas.width = this.PAGE_WIDTH + (this.CANVAS_PADDING * 2);
    this.canvas.height = this.PAGE_HEIGHT + (this.CANVAS_PADDING * 2);

    // Offset the canvas so that it's padding is evenly spread around the book
    this.canvas.style.top = -this.CANVAS_PADDING + "px";
    this.canvas.style.left = -this.CANVAS_PADDING + "px";

    this.direction = beforePageNum < afterPageNum ? PageFlip.DIRECTION.FORWARD : PageFlip.DIRECTION.BACK;
    if(window.debug) {
      console.log(`[PageFlip constructor] direction:${this.direction}`);
    }

    const className = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', afterPageNum);
    const section = $(`#${constant.Paging.ROOT_ID}`).find(`.${className}:first`);
    section.show();
    if(this.direction === PageFlip.DIRECTION.FORWARD) {
      section.css('width', '');
    } else if(this.direction === PageFlip.DIRECTION.BACK) {
      section.css('width', '0');
    }
  }

  // 描画開始
  // @param [Function] callback コールバック
  startRender(callback = null) {
    let point, timer;
    const className = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', this.flipPageNum);
    const pages = $(`#${constant.Paging.ROOT_ID}`).find(`.${className}:first`);
    if(this.direction === PageFlip.DIRECTION.FORWARD) {
      this.flip = {
        progress: 1,
        target: -0.25,
        page: pages,
      };

      point = this.PAGE_WIDTH;
      return timer = setInterval(() => {
          point -= 50;
          if(point < -this.CANVAS_PADDING) {
            point = -this.CANVAS_PADDING;
            this.flip.progress = 0;
            this.render(point);
            clearInterval(timer);
            $('#pageflip-root').remove();
            if(callback !== null) {
              callback();
            }
          }
          return this.render(point);
        }
        , 50);
    } else if(this.direction === PageFlip.DIRECTION.BACK) {
      this.flip = {
        progress: -0.25,
        target: 1,
        page: pages,
      };
      point = -this.CANVAS_PADDING;
      return timer = setInterval(() => {
          point += 50;
          if(point > this.PAGE_WIDTH) {
            point = this.PAGE_WIDTH;
            this.flip.progress = 1;
            this.render(point);
            clearInterval(timer);
            $('#pageflip-root').remove();
            if(callback !== null) {
              callback();
            }
          }
          return this.render(point);
        }
        , 50);
    }
  }

  // 描画
  // @param [Integer] point 描画X位置
  render(point) {
    if((point < -this.CANVAS_PADDING) || (point > this.PAGE_WIDTH)) {
      return;
    }

    // Reset all pixels in the canvas
    this.context.clearRect(0, 0, this.canvas.width, this.canvas.height);

    // Ease progress towards the target value
    this.flip.progress += (this.flip.target - this.flip.progress) * 0.2;
//    if window.debug
//      console.log('[render] progress: ' + @flip.progress)

    return this.drawFlip(this.flip);
  }

  drawFlip(flip) {
    // Strength of the fold is strongest in the middle of the book
    const strength = 1 - Math.abs(flip.progress);

    const foldWidth = 0;

    // X position of the folded paper
    const foldX = (this.PAGE_WIDTH * flip.progress) + foldWidth;
//    if window.debug
//      console.log('[drawFlip] foldX:' + foldX + ' progress:' + flip.progress)

    // How far the page should outdent vertically due to perspective
    const verticalOutdent = 20 * strength;

    // The maximum width of the left and right side shadows
    const paperShadowWidth = (this.PAGE_WIDTH * 0.5) * Math.max(Math.min(1 - flip.progress, 0.5), 0);
    const rightShadowWidth = (this.PAGE_WIDTH * 0.5) * Math.max(Math.min(strength, 0.5), 0);
    const leftShadowWidth = (this.PAGE_WIDTH * 0.5) * Math.max(Math.min(strength, 0.5), 0);

    // Change page element width to match the x position of the fold
    flip.page.css({'width': Math.max(foldX, 0) + "px", 'z-index': this.zIndex});

    this.context.save();

    // Draw a sharp shadow on the left side of the page
    this.context.strokeStyle = `rgba(0,0,0,${0.05 * strength})`;
    this.context.lineWidth = 30 * strength;
    this.context.beginPath();
    this.context.moveTo(foldX - foldWidth, -verticalOutdent * 0.5);
    this.context.lineTo(foldX - foldWidth, this.PAGE_HEIGHT + (verticalOutdent * 0.5));
    this.context.stroke();


    // Right side drop shadow
    const rightShadowGradient = this.context.createLinearGradient(foldX, 0, foldX + rightShadowWidth, 0);
    rightShadowGradient.addColorStop(0, `rgba(0,0,0,${strength * 0.2})`);
    rightShadowGradient.addColorStop(0.8, 'rgba(0,0,0,0.0)');

    this.context.fillStyle = rightShadowGradient;
    this.context.beginPath();
    this.context.moveTo(foldX, 0);
    this.context.lineTo(foldX + rightShadowWidth, 0);
    this.context.lineTo(foldX + rightShadowWidth, this.PAGE_HEIGHT);
    this.context.lineTo(foldX, this.PAGE_HEIGHT);
    this.context.fill();


    // Left side drop shadow
    const leftShadowGradient = this.context.createLinearGradient(foldX - foldWidth - leftShadowWidth, 0, foldX - foldWidth, 0);
    leftShadowGradient.addColorStop(0, 'rgba(0,0,0,0.0)');
    leftShadowGradient.addColorStop(1, `rgba(0,0,0,${strength * 0.15})`);

    this.context.fillStyle = leftShadowGradient;
    this.context.beginPath();
    this.context.moveTo(foldX - foldWidth - leftShadowWidth, 0);
    this.context.lineTo(foldX - foldWidth, 0);
    this.context.lineTo(foldX - foldWidth, this.PAGE_HEIGHT);
    this.context.lineTo(foldX - foldWidth - leftShadowWidth, this.PAGE_HEIGHT);
    this.context.fill();


    // Gradient applied to the folded paper (highlights & shadows)
    const foldGradient = this.context.createLinearGradient(foldX - paperShadowWidth, 0, foldX, 0);
    foldGradient.addColorStop(0.35, '#fafafa');
    foldGradient.addColorStop(0.73, '#eeeeee');
    foldGradient.addColorStop(0.9, '#fafafa');
    foldGradient.addColorStop(1.0, '#e2e2e2');

    this.context.fillStyle = foldGradient;
    this.context.strokeStyle = 'rgba(0,0,0,0.06)';
    this.context.lineWidth = 0.5;

    // Draw the folded piece of paper
    this.context.beginPath();
    this.context.moveTo(foldX, 0);
    this.context.lineTo(foldX, this.PAGE_HEIGHT);
    this.context.quadraticCurveTo(foldX, this.PAGE_HEIGHT + (verticalOutdent * 2), foldX - foldWidth, this.PAGE_HEIGHT + verticalOutdent);
    this.context.lineTo(foldX - foldWidth, -verticalOutdent);
    this.context.quadraticCurveTo(foldX, -verticalOutdent * 2, foldX, 0);

    this.context.fill();
    this.context.stroke();

    return this.context.restore();
  }
}

PageFlip.initClass();
