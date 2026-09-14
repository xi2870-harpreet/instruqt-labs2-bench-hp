resource "page" "overview" {
  title = "What this bench is for"
  file  = "instructions/01-overview.md"
}

resource "page" "tasks" {
  title = "Tasks"
  file  = "instructions/02-tasks.md"

  activities = {
    net_ready = resource.task.net_ready
    http_ok   = resource.task.http_ok
  }
}

resource "page" "quiz" {
  title = "Quiz"
  file  = "instructions/03-quiz.md"

  activities = {
    bench = resource.quiz.bench
  }
}

resource "lab" "main" {
  title       = "Labs 2.0 probe bench"
  description = "A deliberately boring lab that always starts, used as a stable base for probing Labs 2.0 features and reproducing bugs."

  settings {
    timelimit {
      duration   = "1h"
      show_timer = true
    }
  }

  layout = resource.layout.default

  content {
    chapter "bench" {
      title = "Bench"

      page "overview" {
        reference = resource.page.overview
      }

      page "tasks" {
        reference = resource.page.tasks
      }
    }

    chapter "knowledge" {
      title = "Knowledge"

      page "quiz" {
        reference = resource.page.quiz
      }
    }
  }
}
