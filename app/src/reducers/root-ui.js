import * as actions from './../actions/types'
import { loadKeyState } from '../utils/localStorage'

const isNightModeEnabled = loadKeyState('isNightModeEnabled') || false

if (isNightModeEnabled) {
  document.body.classList.add('night-mode')
}

export const initialState = {
  isFeedbackModalOpened: false,
  isOnline: true,
  loginPending: false,
  loginSuccess: false,
  loginError: false,
  loginErrorMessage: '',
  isGDPRModalOpened: false,
  isNightModeEnabled
}

export default (state = initialState, action) => {
  switch (action.type) {
    case 'TOGGLE_FEEDBACK_MODAL':
      return {
        ...state,
        isFeedbackModalOpened: !state.isFeedbackModalOpened
      }
    case actions.APP_CHANGE_ONLINE_STATUS:
      return {
        ...state,
        isOnline: action.payload.isOnline
      }
    case actions.USER_LOGIN_PENDING:
      return {
        ...state,
        loginPending: true
      }
    case actions.USER_LOGIN_SUCCESS:
      return {
        ...state,
        loginPending: false,
        loginSuccess: true
      }
    case actions.USER_LOGIN_FAILED:
      return {
        ...state,
        loginPending: false,
        loginSuccess: false,
        loginError: true,
        loginErrorMessage: action.payload
      }
    case actions.APP_SHOW_GDPR_MODAL:
      return {
        ...state,
        isGDPRModalOpened: true
      }
    case actions.APP_TOGGLE_GDPR_MODAL:
      return {
        ...state,
        isGDPRModalOpened: !state.isGDPRModalOpened
      }
    case actions.USER_SETTING_GDPR:
      const { privacyPolicyAccepted = false } = action.payload
      return {
        ...state,
        isGDPRModalOpened: !privacyPolicyAccepted
      }
    case actions.APP_USER_NIGHT_MODE_SAVE:
      return {
        ...state,
        isNightModeEnabled: action.payload
      }
    default:
      return state
  }
}
