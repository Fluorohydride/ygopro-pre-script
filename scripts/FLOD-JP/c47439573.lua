--無情なはたき落とし
--Ruthless Drop Off
--Script by nekrozar
function c47439573.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_HANDES)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c47439573.condition)
	e1:SetTarget(c47439573.target)
	e1:SetOperation(c47439573.activate)
	c:RegisterEffect(e1)
end
function c47439573.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c47439573.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c47439573.cfilter,1,nil,1-tp)
end
function c47439573.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c47439573.filter(c,e,tp)
	return c:IsRelateToEffect(e) and c47439573.cfilter(c,tp)
end
function c47439573.rmfilter(c,g)
	return c:IsAbleToRemove() and g:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function c47439573.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c47439573.filter,nil,e,tp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		local tg=g:Filter(c47439573.rmfilter,nil,dg)
		if tg:GetCount()>0 then
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		end
		Duel.ShuffleHand(1-tp)
	end
end
