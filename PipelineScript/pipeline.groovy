stage 'Code Stability'
build 'Code Stability JobDsl'
stage 'Quality Checks'
parallel(
"Quality Checks" :
{
build 'Code Coverage Test JobDsl'
build 'Code Stability JobDsl'
}
)
stage 'Deployment'
build 'Deployment jobdsl'
stage 'Functional Test'
build 'Selenimun Test JobDsl'
