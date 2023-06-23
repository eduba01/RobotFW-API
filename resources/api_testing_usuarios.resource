*** Settings ***
Documentation    Testes de API
Resource         ../resources/base.robot
Resource         ../global_variables.robot
Library          RequestsLibrary
Library          String
Library          Collections 

*** Keywords ***
Criar um usuário novo
    base.Novo usuario

Cadastrar o usuário criado na ServeRest
    [Arguments]               ${email}  ${status_code_desejado}
    base.Cadastrar usuario    ${email}  ${status_code_desejado}

Conferir se o usuário foi cadastrado corretamente
    Log  ${RESPOSTA}
    Dictionary Should Contain Item  ${RESPOSTA}  message  Cadastro realizado com sucesso
    Dictionary Should Contain Key   ${RESPOSTA}  _id

Vou repetir o cadastro do usuário
    Cadastrar o usuário criado na ServeRest  email=${EMAIL_TESTE}  status_code_desejado=400

Verificar se a API não permitiu o cadastro repetido
    Dictionary Should Contain Item    ${RESPOSTA}    message    Este email já está sendo usado

Consultar os dados do novo usuário
    ${resposta_consulta}  GET On Session  alias=ServeRest  url=/usuarios/${ID_USUARIO}  expected_status=200
   
    # Obtendo as propriedades do objeto response
    Log   ${resposta_consulta.status_code}
    Log   ${resposta_consulta.reason}
    Log   ${resposta_consulta.headers}
    Log   ${resposta_consulta.elapsed}
    Log   ${resposta_consulta.text}
    Log   ${resposta_consulta.json()}
    
    Set Test Variable     ${RESP_CONSULTA}  ${resposta_consulta.json()}

Conferir os dados retornados
    Log   ${RESP_CONSULTA}
    Dictionary Should Contain Item    ${RESP_CONSULTA}    nome            Fulano da Silva
    Dictionary Should Contain Item    ${RESP_CONSULTA}    email           ${EMAIL_TESTE}
    Dictionary Should Contain Item    ${RESP_CONSULTA}    password        1234
    Dictionary Should Contain Item    ${RESP_CONSULTA}    administrador   true
    Dictionary Should Contain Item    ${RESP_CONSULTA}    _id             ${ID_USUARIO}
