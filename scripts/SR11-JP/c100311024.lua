--ドラグニティ・ドラフト

--Scripted by mallu11
function c100311024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100311024+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100311024.target)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c100311024.immtg)
	e2:SetValue(c100311024.efilter)
	c:RegisterEffect(e2)
end
function c100311024.thfilter(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0x29) and c:IsAbleToHand()
end
function c100311024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100311024.thfilter(chkc) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(c100311024.thfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(100311024,0)) then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c100311024.activate)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectTarget(tp,c100311024.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c100311024.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c100311024.immtg(e,c)
	return c:GetOriginalLevel()>=5 and c:IsSetCard(0x29) and Duel.GetAttacker()==c
end
function c100311024.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
