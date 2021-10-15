--ブルーアイズ・タイラント・ドラゴン
--
--Script by JoyJ
function c101107037.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,89631139,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),1,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c101107037.spcon)
	e2:SetOperation(c101107037.spop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c101107037.efilter)
	c:RegisterEffect(e3)
	--attack all
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(42230449,0))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1)
	e5:SetTarget(c101107037.sstg)
	e5:SetOperation(c101107037.ssop)
	c:RegisterEffect(e5)
end
function c101107037.sstgfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c101107037.sstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and c101107037.sstgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101107037.sstgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	Duel.SelectTarget(tp,c101107037.sstgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c101107037.ssop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SSet(tp,tc)
	end
end
function c101107037.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c101107037.speqfilter(c)
	return c:IsFaceup() and (c:GetOriginalType() & TYPE_FUSION)>0
end
function c101107037.spfilter(c,fc,tp)
	local eg=c:GetEquipGroup()
	return eg:IsExists(c101107037.speqfilter,1,nil) and c:IsCode(89631139)
		and c:IsReleasable() and Duel.GetLocationCountFromEx(tp,tp,c,fc)>0
		and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL)
end
function c101107037.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp,c101107037.spfilter,1,nil,c,tp)
end
function c101107037.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c101107037.spfilter,1,1,nil,c,tp)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
