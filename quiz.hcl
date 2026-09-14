resource "single_choice_question" "which_error" {
  question = "A container dies during startup. Which resource does the error message blame?"
  answer   = "The network"

  distractors = [
    "The container",
    "The image registry",
    "The task check script",
  ]

  hints = ["Think about what the CNI plugin reports when the netns is gone."]
  tags  = ["labs2", "sandbox"]
}

resource "multiple_choice_question" "startup_safe" {
  question = "Which container startup steps are safe to run before the sandbox network is attached?"

  answer = [
    "Writing a config file",
    "Creating a user",
  ]

  distractors = [
    "Resolving your own address with hostname -i",
    "Curling another container by alias",
  ]

  tags = ["labs2", "sandbox"]
}

resource "text_answer_question" "probe_type" {
  question = "Which health_check block type opens a TCP connection and passes if it succeeds?"
  answer   = "tcp"
  tags     = ["labs2", "health-check"]
}

resource "numeric_answer_question" "attach_gap" {
  question = "Roughly how many seconds does a container run before the CNI attach begins? (whole seconds)"
  answer   = 2
  exact    = false
  tags     = ["labs2", "sandbox"]
}

resource "quiz" "bench" {
  questions = [
    resource.single_choice_question.which_error,
    resource.multiple_choice_question.startup_safe,
    resource.text_answer_question.probe_type,
    resource.numeric_answer_question.attach_gap,
  ]

  show_hints   = true
  show_answers = true
}
