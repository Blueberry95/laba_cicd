pipelineJob('Prod') {
    definition {
        cps {
            script(readFileFromWorkspace('jenkins/jenkinsfiles/prod'))
            sandbox()
        }
    }
}
