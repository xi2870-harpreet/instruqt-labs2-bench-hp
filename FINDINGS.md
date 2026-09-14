# Findings from the probe bench

Lab: `instruqt-support / instruqt-labs2-bench-hp`
Repo: https://github.com/xi2870-harpreet/instruqt-labs2-bench-hp

---

## B1 — the numeric question prompt carries a stray "Quiz: " prefix  (P3, believed new)

All four question types render a muted prompt above the question. Three of them
read cleanly; the numeric one leaks what looks like an i18n key prefix.

| Question type | Rendered prompt |
|---|---|
| `single_choice_question` | Select the only correct answer |
| `multiple_choice_question` | Select all the correct answers |
| `text_answer_question` | Enter the correct answer |
| `numeric_answer_question` | **Quiz: Enter the correct number** |

All four are the same element and class:

```
DIV  class="text-sm text-lab-agent-foreground-muted"
```

so this is the string itself, not styling or a different component.

### Reproduce

Play `instruqt-labs2-bench-hp` and open the **Quiz** page under the *Knowledge*
chapter. The four questions appear in the order above.

---

## Confirmed working (recorded so it is not re-tested)

These all behaved correctly on 2026-09-14 and are the reason the bench is
trustworthy as a baseline:

- **Two containers on one network**, with `aliases` resolving (`http://web/`
  reachable from `container.shell`).
- **`http` health check** on `container.web` — gated startup correctly.
- **Task check scripts** run in the target container and report authored
  failure messages.
- **`solve` scripts** run and flip the activity to *Solved for you*.
- **Activity gating** — "Complete 1 activity to continue" blocked the Next page
  button until a task passed.
- **Three tab types** render: `terminal`, `service`, `external_website`.
- **All four question types** render with the right input controls (radio,
  checkbox, text, number).
- **Two chapters / three pages**, markdown tables and fenced code with a working
  copy button.
- **The startup-ordering guard works** — `task.net_ready` passed, so the
  `until hostname -i` wrapper does keep a container alive through the window
  where it has no network.

---

## Not a finding (my own error, recorded so it is not chased)

On the first import attempt the lab appeared to be created but was missing from
the labs list, and its manage URL span forever. Both were my fault plus one real
but minor UI issue:

- The import silently did nothing because I clicked the submit button with a
  synthetic `.click()`, which the form does not act on. A real click imported it
  first time.
- The infinite spinner is simply how the manage UI renders a **lab that does not
  exist** — `/manage/instruqt-support/labs/this-lab-does-not-exist-xyz123`
  behaves identically. Worth reporting separately as "no 404 for a missing lab",
  but it is not an import bug.
