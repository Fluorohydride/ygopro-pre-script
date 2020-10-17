--スナバロン・ドリャトレンティアイ

--Scripted by Xylen09

--Sunavalon Dryatrentiay

function c100272113.initial_effect(c)

  --Link Summon

  c:EnableReviveLimit()

  aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_LINK),2)

  --Search

  local e1=Effect.CreateEffect(c)

  e1:SetDescription(aux.Stringid(100272113,0))

  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)

  e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)

  e1:SetProperty(EFFECT_FLAG_DELAY)

  e1:SetCode(EVENT_SPSUMMON_SUCCESS)

  e1:SetCondition(c100272113.spcon)

  e1:SetTarget(c100272113.sptg)

  e1:SetOperation(c100272113.spop)

  c:RegisterEffect(e1)

  --Cannot be target for attacks/Not Preventing for direct Attack

  local e2=Effect.CreateEffect(c)

  e2:SetType(EFFECT_TYPE_SINGLE)

  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)

  e2:SetRange(LOCATION_MZONE)

  e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)

  e2:SetValue(aux.tgoval)

  c:RegisterEffect(e2)

  local e3=Effect.CreateEffect(c)

  e3:SetType(EFFECT_TYPE_SINGLE)

  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)

  e3:SetCode(EFFECT_IGNORE_BATTLE_TARGET)

  e3:SetRange(LOCATION_MZONE)

  e3:SetValue(aux.imval1)

  c:RegisterEffect(e3)

  --Destroy Cards

  local e2=Effect.CreateEffect(c)

  e2:SetDescription(aux.Stringid(100272113,0))

  e2:SetCategory(CATEGORY_DESTROY)

  e2:SetType(EFFECT_TYPE_IGNITION)

  e2:SetRange(LOCATION_MZONE)

  e2:SetCountLimit(1)

  e2:SetCost(c100272113.descost)

  e2:SetTarget(c100272113.destg)

  e2:SetOperation(c100272113.desop)

  c:RegisterEffect(e2)

end

function c100272113.spcon(e,tp,eg,ep,ev,re,r,rp)

  return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)

end

function c100272113.filter(c)

  return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x256) and c:IsAbleToHand()

end

function c100272113.sptg(e,tp,eg,ep,ev,re,r,rp,chk)

  if chk==0 then return Duel.IsExistingMatchingCard(c100272113.filter,tp,LOCATION_DECK,0,1,nil) end

  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)

end

function c100272113.spop(e,tp,eg,ep,ev,re,r,rp)

  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)

  local g=Duel.SelectMatchingCard(tp,c100272113.filter,tp,LOCATION_DECK,0,1,1,nil)

  if g:GetCount()>0 then

    Duel.SendtoHand(g,nil,REASON_EFFECT)

    Duel.ConfirmCards(1-tp,g)

  end

end

function c100272113.cfilter(c,tp,g)

  return c:IsType(TYPE_LINK) and g:IsContains(c) and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)

end

function c100272113.descost(e,tp,eg,ep,ev,re,r,rp,chk)

  local lg=e:GetHandler():GetLinkedGroup()

  if chk==0 then return Duel.CheckReleaseGroup(tp,c100272113.cfilter,1,nil,tp,lg) end

  local g=Duel.SelectReleaseGroup(tp,c100272113.cfilter,1,1,nil,tp,lg)

  e:SetLabel(g:GetFirst():GetLink())

  Duel.Release(g,REASON_COST)

end

function c100272113.destg(e,tp,eg,ep,ev,re,r,rp,chk)

  if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,ct,nil) end

  local ct=e:GetLabel()

  local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,ct,nil)

  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)

end

function c100272113.desop(e,tp,eg,ep,ev,re,r,rp)

  local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,ct,nil)

  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)

  local dg=g:Select(tp,1,e:GetLabel(),nil)

  Duel.HintSelection(dg)

  Duel.Destroy(dg,REASON_EFFECT)

end
