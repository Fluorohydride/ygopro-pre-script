--ドレミコード・ハルモニア

--scripted by Xylen5967
function c100416024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100416024,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,100416024)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c100416024.thtg)
	e2:SetOperation(c100416024.thop)
	c:RegisterEffect(e2)
	--increase scale
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100416024,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,100416024+100)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c100416024.sctg)
	e3:SetOperation(c100416024.scop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100416024,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,100416024+200)
	e4:SetCondition(c100416024.descon)
	e4:SetOperation(c100416024.desop)
	c:RegisterEffect(e4)
end
function c100416024.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x265) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100416024.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100416024.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c100416024.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100416024.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100416024.scfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x265) and c:GetOriginalType()&TYPE_PENDULUM>0
end
function c100416024.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100416024.scfilter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c100416024.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c100416024.scfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	local sc=g:GetFirst() 
	if sc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(sc:GetLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		sc:RegisterEffect(e2)
	end
end
function c100416019.desfilter(c) 
	local lsc=c:GetLeftScale()
	local rsc=c:GetRightScale()
	return ((lsc%2~=0 or rsc%2~=0) and (lsc%2~=0 or rsc%2~=0)) and c:GetOriginalType()&TYPE_PENDULUM>0 and c:IsFaceup()
end
function c100416024.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100416024.desfilter,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)>=3
end
function c100416024.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,1,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
