--天威龍－ナハタ
--
--scripted by JoyJ
function c101009015.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101009015,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101009015)
	e1:SetCondition(c101009015.spcon)
	e1:SetTarget(c101009015.sptg)
	e1:SetOperation(c101009015.spop)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101009015,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,101009015+100)
	e2:SetCondition(c101009015.atkcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c101009015.atkop)
	c:RegisterEffect(e2)
end
function c101009015.spcfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c101009015.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c101009015.spcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101009015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101009015.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101009015.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if d:IsControler(tp) then a,d=d,a end
	e:SetLabelObject(d)
	return not a:IsType(TYPE_EFFECT) and d:IsControler(1-tp)
		and d:IsFaceup() and a:IsFaceup()
end
function c101009015.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-1500)
	tc:RegisterEffect(e1)
end
