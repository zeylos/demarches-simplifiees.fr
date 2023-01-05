import { ApplicationController } from './application_controller';

export class BatchOperationController extends ApplicationController {
  static targets = ['form', 'input', 'submit'];

  declare readonly formTarget: HTMLFormElement;
  declare readonly submitTarget: HTMLInputElement;
  declare readonly inputTargets: HTMLInputElement[];

  connect() {
    this.formTarget.addEventListener(
      'submit',
      this.interceptFormSubmit.bind(this)
    );
  }

  // DSFR recommends a <input type="submit" /> or <button type="submit" /> a form (not a <select>)
  // but we have many actions on the same form (archive all, accept all, ...)
  // so we intercept the form submit, and set the BatchOperation.operation by hand using the Event.submitter
  interceptFormSubmit(event: SubmitEvent) {
    const submitter = event.submitter as HTMLInputElement;

    submitter.setAttribute('value', submitter.dataset.submitterOperation || '');

    return event;
  }

  onCheckOne(event: Event) {
    this.toggleSubmitButtonWhenNeeded();
    return event;
  }

  onCheckAll(event: Event) {
    const target = event.target as HTMLInputElement;

    this.inputTargets.forEach((e) => (e.checked = target.checked));
    this.toggleSubmitButtonWhenNeeded();
    return event;
  }

  toggleSubmitButtonWhenNeeded() {
    const available = this.inputTargets.some((e) => e.checked);
    if (available) {
      this.submitTarget.removeAttribute('disabled');
    } else {
      this.submitTarget.setAttribute('disabled', 'disabled');
    }
  }
}