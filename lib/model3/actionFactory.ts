import Account from './account'
import SpendCHIPs from './actions/spendCHIPs'
import Action from './action'
import FindNewSpendingTarget from './actions/findNewSpendingTarget'
import FindNewIncomeSource from './actions/findNewIncomeSource'
import AskForLift from './actions/askForLift'

class ActionFactory {
  public static createAction(actionType: string, account: Account) {
    var action: Action

    if (actionType === 'NewSpendingSource') {
      action = new FindNewSpendingTarget(account)
    } else if (actionType === 'NewIncomeSource') {
      action = new FindNewIncomeSource(account)
    } else if (actionType === 'SpendCHIPs') {
      action = new SpendCHIPs(account)
    } else if (actionType === 'AskForLift') {
      action = new AskForLift(account)
    }
    // Add more types here...
    else {
      throw 'Invalid Action type given.'
    }

    return action
  }
}

export default ActionFactory
