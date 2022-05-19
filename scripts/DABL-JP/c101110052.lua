-- 黒羽の旋風 
--Script by Corvus1998
function c101110052.initial_effect(c)
	--- has dragon in content
	aux.AddCodeList(c, 9012916)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110052,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c101110052.spCondition)
	e2:SetTarget(c101110052.spTarget)
	e2:SetOperation(c101110052.spOperation)
	c:RegisterEffect(e2)

	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c101110052.rpTarget)
	e3:SetValue(c101110052.rpValue)
	e3:SetOperation(c101110052.rpOperation)
	c:RegisterEffect(e3)
end

function c101110052.spConFilter(c, tp)
	return c:IsSummonPlayer(tp) and c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_DARK)
			and c:IsPreviousLocation(LOCATION_EXTRA)
end

function c101110052.spTgFilter(c, e, tp, limitAtk)
	return (c:IsSetCard(0x33) or c:IsCode(9012916)) and (c:GetAttack() < limitAtk)
				and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c101110052.spCondition(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(c101110052.spConFilter, nil, tp) > 0
end

function c101110052.spTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local limitAtk = 0
	local conGroup = eg:Filter(c101110052.spConFilter, nil, tp):GetMaxGroup(Card.GetAttack)
	local conCard = conGroup:GetFirst()
	if conCard then
		limitAtk = conCard:GetAttack()
	end

	if chkc then 
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
					and c101110052.spTgFilter(c,e,tp,limitAtk)
	end

	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsExistingTarget(c101110052.spTgFilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,limitAtk)
	end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101110052.spTgFilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,limitAtk)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c101110052.spOperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c101110052.rpFilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)
		and c:IsAttribute(ATTRIBUTE_DARK) and c:IsControler(tp) and not c:IsReason(REASON_REPLACE)
end
function c101110052.rpTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(c101110052.rpFilter,nil,tp)
		return count > 0 and Duel.IsCanRemoveCounter(tp,1,0,0x10,1,REASON_EFFECT)
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c101110052.rpValue(e,c)
	return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)
		and c:IsAttribute(ATTRIBUTE_DARK) and c:IsControler(e:GetHandlerPlayer()) and not c:IsReason(REASON_REPLACE)
end

function c101110052.rpOperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveCounter(tp,1,0,0x10,1,REASON_EFFECT)
end