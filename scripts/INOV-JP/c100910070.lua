--イカサマ御法度
--No Cheaters Allowed
--Script by nekrozar
function c100910070.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100910070,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100910070,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c100910070.condition)
	e2:SetCost(c100910070.cost)
	e2:SetTarget(c100910070.target)
	e2:SetOperation(c100910070.activate)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e3)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_SELF_TOGRAVE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c100910070.sdcon)
	c:RegisterEffect(e4)
end
function c100910070.cfilter(c,tp)
	return c:GetSummonPlayer()==1-tp and c:IsPreviousLocation(LOCATION_HAND)
end
function c100910070.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100910070.cfilter,1,nil,tp)
end
function c100910070.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(100910070)==0 end
	e:GetHandler():RegisterFlagEffect(100910070,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c100910070.filter(c)
	return c:GetSummonLocation()==LOCATION_HAND and c:IsAbleToHand()
		and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c100910070.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100910070.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c100910070.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c100910070.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c100910070.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c100910070.sdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe6) and c:IsType(TYPE_SYNCHRO)
end
function c100910070.sdcon(e)
	return not Duel.IsExistingMatchingCard(c100910070.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
