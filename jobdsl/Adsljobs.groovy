nestedView('dsl-jobs') {
    views {
        listView('dsl-jobs') {
            jobs {
                names('Code Coverage Test JobDsl', 'Code Quality Test JobDsl', 'Code Stability JobDsl', 'Deployment jobdsl', 'PipeLine JobDsl', 'Release JobDsl', 'Selenimun Test JobDsl')
            }
            columns {
                status()
                weather()
                name()
                lastSuccess()
                lastFailure()
            }
        }
        listView('manual-jobs') {
            jobs {
                names('CodeCoverage', 'CodeQuality', 'CodeQuality', 'Deployment', 'IntegrationTest', 'Release')
            }
            columns {
                status()
                weather()
                name()
                lastSuccess()
                lastFailure()
            }
        }
    }
}
