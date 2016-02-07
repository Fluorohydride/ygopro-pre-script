--創世の竜騎士
--Dragon Knight of Creation
--Scripted by Eerie Code-6119
function c100200113.initial_effect(c)
  --Level
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_LEVEL)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetValue(4)
  e1:SetCondition(c100200113.lvcon)
  c:RegisterEffect(e1)
  --Send to grave
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(100200113,0))
  e2:SetCategory(CATEGORY_TOGRAVE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_BATTLE_DESTROYING)
  e2:SetCondition(aux.bdocon)
  e2:SetTarget(c100200113.tgtg)
  e2:SetOperation(c100200113.tgop)
  c:RegisterEffect(e2)
  --Special Summon
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(100200113,1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1,100200113)
  e3:SetCost(c100200113.spcost)
  e3:SetTarget(c100200113.sptg)
  e3:SetOperation(c100200113.spop)
  c:RegisterEffect(e3)
end
function c100200113.lvcon(e)
  return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c100200113.tgfil(c)
  return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_DRAGON) and (c:GetLevel()==7 or c:GetLevel()==8) and c:IsAbleToGrave()
end
function c100200113.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c100200113.tgfil,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c100200113.tgop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c100200113.tgfil,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
	Duel.SendtoGrave(g,REASON_EFFECT)
  end
end
function c100200113.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c100200113.spfil(c,e,tp)
  return c:IsRace(RACE_DRAGON) and (c:GetLevel()==7 or c:GetLevel()==8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100200113.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c100200113.spfil(chkc,e,tp) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and e:GetHandler():IsAbleToGrave() and Duel.IsExistingTarget(c100200113.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c100200113.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c100200113.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return end
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)>0 then
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
  end
end
