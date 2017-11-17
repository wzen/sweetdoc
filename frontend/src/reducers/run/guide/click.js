import GuideBase from './base';

// クリックガイド
export default class ClickGuide extends GuideBase {

  // キーフレーム追加
  // @param [Array] items アイテムオブジェクト
  // @return [String] KeyFrame
  static addItemKeyFrams(items) {
    const _itemKeyFrames = function(item) {
      const kf = `\
click_focus_${item.id} {
      0% {
        background-size: 100px 100px;
        opacity: 0;
      }
      50% {
        background-size: 100px 100px;
        opacity: 0;
      }
      100% {
        background-size: 80px 80px;
        opacity: 1;
      }
    }\
`;
      const anim = `\
.click_guide_${item.id}
{
-webkit-animation-name: click_focus_${item.id};
-moz-animation-name: click_focus_${item.id};
}\
`;

      return `\
@-webkit-keyframes ${kf}
@-moz-keyframes ${kf}
${anim}\
`;
    };

    let css = '';
    for(let item of Array.from(items)) {
      css += _itemKeyFrames.call(this, item);
    }
    this.removeItemKeyFrames();
    return window.cssCode.append($(`<div class='chapter_itemkeyframes'><style type='text/css'>${css}</style></div>`));
  }

  // キーフレーム削除
  static removeItemKeyFrames() {
    return window.cssCode.find('.chapter_itemkeyframes').remove();
  }

  // ガイド表示
  // @param [Array] items アイテムオブジェクト
  static showGuide(items) {
    this.hideGuide();
    this.addItemKeyFrams(items);
    return (() => {
      const result = [];
      for(let item of Array.from(items)) {
        const color = this.focusColor(item);
        const guideClassName = `click_guide_${item.id}`;
        const style = ''; // "width:#{item.itemSize.w}px;height:#{item.itemSize.h}px;"
        result.push(item.getJQueryElement().append($(`<div class='guide guide_click ${color} ${guideClassName}' style='${style}' data-html2canvas-ignore='true'></div>`)));
      }
      return result;
    })();
  }

  // ガイド非表示
  static hideGuide() {
    this.removeItemKeyFrames();
    return $('.guide_click').remove();
  }

  // フォーカス時の色を判定
  // @param [Object] item アイテムオブジェクト
  static focusColor(item) {
    let c;
    let background = item.getJQueryElement().find('.context_base:first').css('background');

    // gradient抜き出し
    const startIndex = background.indexOf('gradient(') + 'gradient('.length;
    let endIndex = background.length - 1;
    let count = 1;
    for(let i = startIndex, end = background.length, asc = startIndex <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
      c = background.charAt(i);
      if(c === '(') {
        count += 1;
      } else if(c === ')') {
        count -= 1;
      }
      if(count <= 0) {
        endIndex = i;
        break;
      }
    }
    background = background.substring(startIndex, endIndex);

    // カラーコード検索 rgb形式
    const re = /((2[0-4]\d|25[0-5]|1\d{1,2}|[1-9]\d|\d)( ?, ?)){2}(2[0-4]\d|25[0-5]|1\d{1,2}|[1-9]\d|\d)/g;
    const colors = background.match(re);
    if((colors === null)) {
      // 見つからない場合は黒とする
      return 'black';
    }

    // グラデーションの平均値計算
    let averageColors = [0, 0, 0];
    for(c of Array.from(colors)) {
      const arr = c.split(',');
      averageColors[0] += parseInt(arr[0]);
      averageColors[1] += parseInt(arr[1]);
      averageColors[2] += parseInt(arr[2]);
    }
    averageColors = $.map(averageColors, c => parseInt(c / colors.length));

    // 最も大きい差分の色を取得
    const baseColors = {
      red: [255, 0, 0],
      black: [0, 0, 0],
      blue: [0, 0, 255],
      yellow: [255, 255, 0]
    };
    let maxDiff = 0;
    let targetKey = null;
    for(let k in baseColors) {
      const v = baseColors[k];
      const diffs = Math.abs(averageColors[0] - v[0]) + Math.abs(averageColors[1] - v[1]) + Math.abs(averageColors[2] - v[2]);
      if(diffs > maxDiff) {
        targetKey = k;
        maxDiff = diffs;
      }
    }

    return targetKey;
  }
}