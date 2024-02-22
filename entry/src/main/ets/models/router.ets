import { ExceptionListModel } from '.'

export class CommonRouterParams {
  id?: string = ''
  oldTime?: string = ''
  address?: string = ''
  addExcept?: boolean = false
  formData?: ExceptionListModel
}