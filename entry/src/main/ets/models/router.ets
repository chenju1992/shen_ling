import { ExceptionListModel } from '.'

export class CommonRouterParams {
  id?: string = ''
  oldTime?: string = ''
  address?: string = ''
  addExcept?: boolean = false
  start?: string = ''
  end?: string = ""
  formData?: ExceptionListModel
}