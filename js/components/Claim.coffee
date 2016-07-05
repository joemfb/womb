clas = require 'classnames'

Actions = require '../Actions.coffee'

{FromStore} = Scry = require './Scry.coffee'

Label = require './Label.coffee'

Shop = require './Shop.coffee'
PassInput = require './PassInput.coffee'

recl = React.createClass
rele = React.createElement
name = (displayName,component)-> _.extend component, {displayName}

{div,b,h6,p,span,code} = React.DOM

SHOP = false # enable ship shop

unless SHOP
  Shop = (type,length)-> 
    ({})-> h6 {}, "Distribution of ",type," not yet live."

Mail = (email)-> code {className:"email"}, email
History = (history)->
  if !history.length
    "purchased directly from Tlon Inc. "
  else
    span {}, "previously owned by ",
      for who, key in history
         span {key}, (Mail who)
      "and Tlon Inc. "

Stars   = Shop "stars", 7
Planets = Shop "planets", 14
  
Balance = Scry "/balance/:pass", ({balance})->
    if balance.fail
      return div {}, Label "Invalid passcode", "warning"
    {planets,stars,owner,history} = balance
    div {},
      h6 {}, "Balance"
      p {}, "Hello ", (Mail owner)
      p {},
        "This balance was "
        History history
        "It contains "
        (b {}, planets or "no"), " Planets "
        "and ", (b {}, stars or "no"), " Stars."
      if stars then rele Stars
      if planets then rele Planets

module.exports = name "Claim", FromStore "pass", ({pass})->
  div {},
      p {}, "Input a passcode to view ship allocation: "
      PassInput {minLength:12,defaultValue:pass,onInputPass:Actions.setPasscode}
      if pass then rele Balance, {pass}
