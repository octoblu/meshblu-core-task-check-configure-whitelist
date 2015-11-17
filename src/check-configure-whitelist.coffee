WhitelistManager = require 'meshblu-core-manager-whitelist'
http             = require 'http'

class VerifyConfigureWhitelist
  constructor: ({@datastore, @whitelistManager}) ->
    @whitelistManager ?= new WhitelistManager datastore: @datastore

  do: (job, callback) =>
    {toUuid, fromUuid, responseId} = job.metadata
    @whitelistManager.canConfigure toUuid, fromUuid, (error, canConfigure) =>
      return @sendResponse responseId, 500, callback if error?
      return @sendResponse responseId, 403, callback unless canConfigure
      @sendResponse responseId, 204, callback

  sendResponse: (responseId, code, callback) =>
    callback null,
      metadata:
        responseId: responseId
        code: code
        status: http.STATUS_CODES[code]

module.exports = VerifyConfigureWhitelist
