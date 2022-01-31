# Release management

Create a log of pushed commits and identify ClickUp tickets related to merged branches.

## :gear: How does it work?

1. Pushed commits are verified and added along with their hash to the output log.
2. The commits related to mergers are identified and it is checked if they have a ticket in ClickUp.
3. The link of the identified tickets is added to the output log.
4. The `BODY_SUCCESS` variable is sent as env variable as the output of the action.

## :rocket: Running in GitHub Actions

Run this action in Github Actions by adding `pcvg/release-management@main` to your steps.

### Parameters

| Name | Meaning                                     | Default                    | Required  |
| ---                 | ---                          | ---                        | ---  |
| `SUCCESS_MSG`       | Top text of the message      | Workflow completed.        | true |
| `CLICKUP_KEY`       | ClickUp API Access Key       | -                          | true |
| `GH_EVENT_BEFORE`   | ID of the previous workflow  | ${{ github.event.before }} | true |
| `GH_SHA`            | SHA of current commit        | ${{ github.sha }}          | true |

### Example

Example of integrating the output env var into a Slack notification.

```yml
name: Example
on:
  push:
    branches:
      - main

jobs:
  be-happy-workflow:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 0
      - name: Run release management
        uses: pcvg/release-management@test
        with:
          SUCCESS_MSG: "Deployment completed. :) "
      - name: Notify Innovation Hub
        if: success()
        uses: pcvg/slack-notification-action@main
        with:
          SLACK_WEBHOOK_URL: "https://hooks.slack.com/services/XXXX"
          TITLE_SUCCESS: "Works!"
          TITLE_FAIL: "Oh :( - Failed"
          BODY_SUCCESS: ${{ env.BODY_SUCCESS }}
          BODY_FAIL: "Deployment failed - Check https://github.com/${{ github.repository }}/commit/${{ github.sha }}/checks|${{ github.repository }}"
```

## ⚖️ License
This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.
