--圣天树之大母神
function c100270213.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c100270213.mfilter,2,99)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100270213,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c100270213.thcon)
	e1:SetTarget(c100270213.thtg)
	e1:SetOperation(c100270213.thop)
	c:RegisterEffect(e1)
	--cannot be battle traget
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100270213,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c100270213.cost)
	e3:SetTarget(c100270213.destg)
	e3:SetOperation(c100270213.desop)
	c:RegisterEffect(e3)
end
function c100270213.mfilter(c)
	return c:IsLinkType(TYPE_LINK)
end
function c100270213.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function c100270213.thfilter(c)
	return c:IsSetCard(0x255) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c100270213.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100270213.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100270213.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100270213.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100270213.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c100270213.desfilter(c,tc,ec)
	return c:GetEquipTarget()~=tc and c~=ec
end
function c100270213.costfilter(c,ec,tp,g)
	return Duel.IsExistingTarget(c100270213.desfilter,tp,0,LOCATION_ONFIELD,1,c,c,ec) and g:IsContains(c) and c:IsType(TYPE_LINK) and c:IsLinkAbove(1)
end
function c100270213.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local ct=0
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.CheckReleaseGroup(tp,c100270213.costfilter,1,c,c,tp,lg)
		else
			return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local g=Duel.SelectReleaseGroup(tp,c100270213.costfilter,1,1,c,c,tp,lg)
		ct=g:GetFirst():GetLink()
		Duel.Release(g,REASON_COST)
	end
	e:SetValue(ct)
	local sg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
end
function c100270213.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetValue()
	local sg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	local g=sg:Select(tp,1,ct,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end