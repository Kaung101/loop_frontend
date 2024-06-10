abstract class FormSubmissionStatus{
  const FormSubmissionStatus();
}
//4 states of form submission
class InitialFormStatus extends FormSubmissionStatus{
  const InitialFormStatus();
}

class FormSubmitting extends FormSubmissionStatus{
  
}

class SubmissionSuccess extends FormSubmissionStatus{
  
}

class SubmissionFailed extends FormSubmissionStatus{
  final Exception exception;

  SubmissionFailed(this.exception);
}