*** Settings ***
Resource         ../global_variables.robot
Library          RequestsLibrary
Library          String
Library          Collections 
  
*** Keywords ***
Novo usuario
    ${palavra_aleatoria}  Generate Random String  length=4  chars=[LETTERS]
    ${palavra_aleatoria}  Convert To Lower Case   ${palavra_aleatoria}
    Set Test Variable     ${EMAIL_TESTE}  ${palavra_aleatoria}@emailteste.com
    Log  ${EMAIL_TESTE}
 

Cadastrar usuario
    [Arguments]  ${email}  ${status_code_desejado}
    ${body}  Create Dictionary
    ...      nome=Fulano da Silva
    ...      email=${email}
    ...      password=1234
    ...      administrador=true   
    Log   ${body}
    
    Criar Sessão na ServeRest

    ${resposta}  POST On Session
    ...          alias=ServeRest
    ...          url=/usuarios
    ...          json=${body}
    ...          expected_status=${status_code_desejado}

    Log  ${resposta.json()}
    
    IF  ${resposta.status_code} == 201
        Set Test Variable    ${ID_USUARIO}  ${resposta.json()["_id"]}
    END

    Set Test Variable    ${RESPOSTA}    ${resposta.json()}

Criar Sessão na ServeRest
    ${headers}  Create Dictionary  accept=application/json  Content-Type=application/json
    Create Session    alias=ServeRest    url=https://serverest.dev   headers=${headers}