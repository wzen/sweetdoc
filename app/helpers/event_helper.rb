module EventHelper
  def self.actionTypeClassNameByActionType(action_type)
    if action_type == Const::ActionEventHandleType::SCROLL
      return Const::ActionEventTypeClassName::SCROLL
    elsif action_type == Const::ActionEventHandleType::CLICK
      return Const::ActionEventTypeClassName::CLICK
    end

    return nil
  end
end

