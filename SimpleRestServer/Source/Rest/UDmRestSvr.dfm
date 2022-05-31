object DmRestSvr: TDmRestSvr
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 234
  Width = 388
  object IdHTTPServer: TIdHTTPServer
    Bindings = <
      item
        IP = '0.0.0.0'
        Port = 443
      end>
    IOHandler = IdServerIOHandlerSSLOpenSSL
    OnConnect = IdHTTPServerConnect
    OnException = IdHTTPServerException
    OnQuerySSLPort = IdHTTPServerQuerySSLPort
    OnCommandGet = IdHTTPServerCommandGet
    Left = 32
    Top = 24
  end
  object IdServerIOHandlerSSLOpenSSL: TIdServerIOHandlerSSLOpenSSL
    SSLOptions.Method = sslvTLSv1_2
    SSLOptions.SSLVersions = [sslvTLSv1_2]
    SSLOptions.Mode = sslmServer
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    OnGetPassword = IdServerIOHandlerSSLOpenSSLGetPassword
    Left = 176
    Top = 25
  end
end
