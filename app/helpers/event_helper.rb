module EventHelper
  def self.actionTypeClassNameByActionType(action_type)
    if action_type == Const::ActionEventHandleType::SCROLL
      return Const::TimelineActionTypeClassName::SCROLL
    elsif action_type == Const::ActionEventHandleType::CLICK
      return Const::TimelineActionTypeClassName::CLICK
    end

    return nil
  end
end

