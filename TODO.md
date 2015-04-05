

# To Do List

- [x] keep everything in one `gherkin3` package without any dependencies
- [ ] create a split tree repository of the src that can be used with `go get`
    - [ ] package: `github.com/cucumber/gherkin3-golang` ?
    - [ ] identify wether it is *go-get-able* or not
- [x] remove code snippet comments 
- [ ] change multi-value return statements to return the error as last value, as it's done in the golang stdlib
- [ ] only make public what needs to be public, check with go doc what makes sense
