<after-login>
  <div class="window">
    <header></header>
    <div class="window-content">
      <div class="pane-group">
        <div class="pane-sm sidebar">
          <sidebar></sidebar>
        </div>
        <div class="pane">
          <main if={ tab == 'contents' }></main>
          <query if={ tab == 'query' }></query>
        <div>
      </div>
    </div>
  </div>


  <script>
    /***********************************************
    * Settings
    ***********************************************/
    var that = this
    that.tab = 'contents'
    that.localProjects = JSON.parse(localStorage.getItem('projects')) || {}


    /***********************************************
    * Observables
    ***********************************************/
    // unmount処理
    that.on('unmount', function() {
      obs.off('projectChanged')
    })

    obs.on('projectChanged', function(projectId){
      if(projectId=='') {
        riot.mount('before-login')
        that.unmount(true)
      }else {
        try {
          fs.statSync(that.localProjects[projectId])
          firestore = new Firestore({
            projectId: projectId,
            keyFilename: that.localProjects[projectId]
          })
          opts.projectId = projectId
          that.unmount(true)
          riot.mount('after-login', 'after-login', {'projectId': projectId})
        }catch(e) {
          alert('Error! Check console for detail.')
          console.log(e)
        }
      }
    })

    obs.on('tabChanged', function(tab){
      that.tab = tab
      that.update()
    })
  </script>
</after-login>
