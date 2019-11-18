--リンクロス

--Scripted by mallu11
function c101012049.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c101012049.mfilter,1)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101012049,0))
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101012049)
	e1:SetCondition(c101012049.tkcon)
	e1:SetTarget(c101012049.tktg)
	e1:SetOperation(c101012049.tkop)
	c:RegisterEffect(e1)
end
function c101012049.mfilter(c)
	return c:IsLinkType(TYPE_LINK) and c:GetLink()>=2
end
function c101012049.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c101012049.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()~=1 then return false end
	if chk==0 then return mg:IsExists(Card.IsType,1,nil,TYPE_LINK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101012149,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT) end
	e:SetLabel(mg:GetFirst():GetLink())
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c101012049.tkop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=e:GetLabel()
	if ft<=0 or ct<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,101012149,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT) then return end
	local count=math.min(ft,ct)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then count=1 end
	repeat
		local token=Duel.CreateToken(tp,101012149)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		count=count-1
	until count==0 or not Duel.SelectYesNo(tp,210)
	Duel.SpecialSummonComplete()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,48068379))
	e1:SetValue(c101012049.lklimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101012049.lklimit(e,c)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end
