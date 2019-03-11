pipelineJob('Stage') {
    definition {
        cps {
            script(readFileFromWorkspace('jenkins/jenkinsfiles/stage'))
            sandbox()
        }
    }
}
