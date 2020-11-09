--氷の壁のクリア・ウォール・ドラゴン
--LUA by Kohana♡
function c100340027.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100340027+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100340027.target)
	c:RegisterEffect(e1)
	--Unaffected
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xf))
	e2:SetCondition(c100340027.IceBarrierCondition)
	e2:SetValue(c100340027.efilter)
	c:RegisterEffect(e2)
end
function c100340027.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x2f) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100340027.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100340027.filter(chkc) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(c100340027.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(100340027,0)) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c100340027.activate)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c100340027.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c100340027.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100340027.imfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2f)
end
function c100340027.IceBarrierCondition(e)
	return Duel.IsExistingMatchingCard(c100340027.imfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,3,nil)
end
function c100340027.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER) and c:GetSummonLocation()==LOCATION_EXTRA
end
