--機殻の凍結
--Qliphort Down
--Script by nekrozar
--Effect is not fully implemented
function c100910076.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100910076.target)
	e1:SetOperation(c100910076.activate)
	c:RegisterEffect(e1)
	--double tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e2:SetCondition(c100910076.dtcon)
	e2:SetValue(c100910076.dtval)
	c:RegisterEffect(e2)
end
function c100910076.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,100910076,0xaa,0x21,4,1800,1000,RACE_MACHINE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100910076.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,100910076,0xaa,0x21,4,1800,1000,RACE_MACHINE,ATTRIBUTE_EARTH) then
		c:AddMonsterAttribute(0,0,0,0,0)
		Duel.SpecialSummonStep(c,1,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetTargetRange(LOCATION_ONFIELD,0)
		e2:SetTarget(c100910076.indtg)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c100910076.indtg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xaa)
end
function c100910076.dtcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c100910076.dtval(e,c)
	return c:IsSetCard(0x10aa)
end
