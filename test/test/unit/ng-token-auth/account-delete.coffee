suite 'account delete', ->
  setup ->
    angular.extend($rootScope.user, validUser)
    $cookieStore.put('auth_headers', validAuthHeader)

  suite 'successful deletion', ->
    successResp =
      success: true

    setup ->
      $httpBackend
        .expectDELETE('/api/auth')
        .respond(201, successResp)

      $auth.destroyAccount()

      $httpBackend.flush()

    test 'account delete event is broadcast by $rootScope', ->
      assert $rootScope.$broadcast.calledWithMatch('auth:account-delete-success', successResp)

    test 'user object is destroyed', ->
      assert.deepEqual($rootScope.user, {})

    test 'local auth headers are destroyed', ->
      assert.isUndefined $auth.retrieveData('auth_headers')

  suite 'failed update', ->
    failedResp =
      success: false
      errors: ['◃┆◉◡◉┆▷']

    setup ->
      $httpBackend
        .expectDELETE('/api/auth')
        .respond(403, failedResp)

      $auth.destroyAccount()

      $httpBackend.flush()

    test 'failed account delete event is broadcast by $rootScope', ->
      assert $rootScope.$broadcast.calledWithMatch('auth:account-delete-error', failedResp)

    test 'user is still defined on root scope', ->
      assert.deepEqual($rootScope.user, validUser)

    test 'auth headers persist', ->
      assert.deepEqual($auth.retrieveData('auth_headers'), validAuthHeader)