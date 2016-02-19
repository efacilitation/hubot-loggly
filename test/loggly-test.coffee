chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'loggly', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/loggly')(@robot)

  it 'registers a hear listener', ->
    expect(@robot.hear).to.have.been.calledWith /loggly get from ([^\s]+?) until ([^\s]+?)$/
