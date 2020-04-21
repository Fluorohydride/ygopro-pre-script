--Necroquip Prism
--
--Script by JoyJ
function c101012084.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101012084)
	e1:SetTarget(c101012084.target)
	e1:SetOperation(c101012084.activate)
	c:RegisterEffect(e1)
end
function c101012084.spfilter(c,lv)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(lv)
end
function c101012084.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4)
		and Duel.IsExistingMatchingCard(c101012084.spfilter,tp,LOCATION_HAND,0,1,nil,c:GetLevel())
		and (not c:IsForbidden())
end
function c101012084.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE)
		and chkc:IsControler(tp)
		and c101012084.filter(c)
		and chkc:IsCanBeEffectTarget(e) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsExistingTarget(c101012084.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c101012084.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,tp,LOCATION_GRAVE)
end
function c101012084.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local lv=tc:GetLevel()
	local c=Duel.SelectMatchingCard(tp,c101012084.spfilter,tp,LOCATION_HAND,0,1,1,nil,lv):GetFirst()
	if c and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		and (not tc:IsForbidden())
		and Duel.Equip(tp,tc,c) then
		local atk=tc:GetAttack()
		if atk>0 then
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_EQUIP)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk/2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(1,0)
		e2:SetValue(c101012084.aclimit)
		e2:SetLabel(tc:GetCode())
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		--equip limit
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_EQUIP_LIMIT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetLabelObject(c)
		e3:SetValue(c101012084.eqlimit)
		tc:RegisterEffect(e3)
	end
end
function c101012084.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function c101012084.eqlimit(e,c)
	return c==e:GetLabelObject()
end
