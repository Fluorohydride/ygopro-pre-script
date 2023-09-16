--狱火机 恶念
function c100211097.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c100211097.matfilter,2,true)

  --spsummon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(100211097,0))
  e1:SetCategory(CATEGORY_TOGRAVE)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCountLimit(1,100211097)
  e1:SetCondition(c100211097.damcon)
  e1:SetTarget(c100211097.damtg)
  e1:SetCost(c100211097.spcost)
  e1:SetOperation(c100211097.spop)
  c:RegisterEffect(e1)

  --tograve
  local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100211097,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,100211097+1000)
	e2:SetTarget(c100211097.thtg)
	e2:SetOperation(c100211097.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
function c100211097.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c100211097.matfilter(c)
  return c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end

function c100211097.spfilter(c,e,tp)
  return c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c100211097.matfilter,tp,LOCATION_DECK,0,c:GetLevel(),nil)
end

function c100211097.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c100211097.fselect(g,count)
	local tc=g:GetFirst():GetLevel()
	return tc<=count
end
function c100211097.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(c100211097.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local tg=Duel.GetMatchingGroup(c100211097.matfilter,tp,LOCATION_DECK,0,nil)
	local count=tg:GetClassCount(Card.GetCode)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		if #tg==0 then return false end
		return cg:CheckSubGroup(c100211097.fselect,1,1,count)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=cg:SelectSubGroup(tp,c100211097.fselect,false,1,1,count)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,rg:GetFirst():GetLevel(),tp,LOCATION_DECK)
end
function c100211097.spop(e,tp,eg,ep,ev,re,r,rp)
  local l = e:GetLabel()
  local g = Duel.GetMatchingGroup(c100211097.matfilter,tp,LOCATION_DECK,0,l,nil)
  local c = g:GetClassCount(Card.GetCode)
  if c >= l then
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	  aux.GCheckAdditional=aux.dncheck
	  local sg=g:SelectSubGroup(tp,aux.TRUE,false,l,l)
	  aux.GCheckAdditional=nil
	  Duel.SendtoGrave(sg, REASON_EFFECT)
  end
end

function c100211097.thfilter(c)
	return c:IsSetCard(0xc5) and ( c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP) ) and c:IsAbleToHand()
end
function c100211097.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100211097.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100211097.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100211097.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
