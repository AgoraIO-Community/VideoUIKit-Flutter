<!-- Please refer to our contributing documentation for any questions on submitting a pull request, or let us know here if you need any help: https://github.com/AgoraIO-Community/VideoUIKit-Flutter/blob/main/CONTRIBUTING.md -->

> Release Version:

## Release Notes

-
-

## Pull request checklist

Please check if your PR fulfills the following requirements:
- [ ] Tests for the changes have been added (for bug fixes / features)
- [ ] Docs have been reviewed and added / updated if needed (for bug fixes / features)
- [ ] The GitHub Actions pass building and linting. Linter returns no warnings or errors.
- [ ] The QA checklist below has been completed

## Pull request type

<!-- Please do not submit updates to dependencies unless it fixes an issue. --> 

<!-- Please try to limit your pull request to one type, submit multiple pull requests if needed. --> 

Please check the type of change your PR introduces:
- [ ] Bugfix
- [ ] Feature
- [ ] Code style update (formatting, renaming)
- [ ] Refactoring (no functional changes, no api changes)
- [ ] Build related changes
- [ ] Documentation content changes
- [ ] Other (please describe): 


## What is the current behavior?
<!-- Please describe the current behavior that you are modifying, or link to a relevant issue. -->

Issue Number: N/A


## What is the new behavior?
<!-- Please describe the behavior or changes that are being added by this PR. -->

-
-
-

## Does this introduce a breaking change?

- [ ] Yes
- [ ] No

<!-- If this introduces a breaking change, please describe the impact and migration path for existing applications below. -->

<!-- If no code has changed, remove this section -->
## QA Checklist

### VideoUIKit Update Checklist (Minor or Patch Release)

- [ ] Using the latest version of Agora's Video SDK
- [ ] Example apps are all functional
- [ ] Core features are still working (both ways across platforms)
	- [ ] Camera + Mic muting works for local and remote users
	- [ ] Users are added and removed correctly when they join and leave the channel
	- [ ] Older versions of the library gracefully handle changes (Create issue if not)
	- [ ] Builtin buttons all work as expected
- [ ] Any newly deprecated methods are flagged as such inline and in documentation

<!-- Remove the next section if not applicable -->

### VideoUIKit Update Checklist (Major Release)

- [ ] The above checklist is completed (except backwards compatibility)
- [ ] Thoroughly tested for crashes, across multiple platforms at the same time

#### QA Notes

## Other information

<!-- Any other information that is important to this PR such as screenshots of how the component looks before and after the change. -->