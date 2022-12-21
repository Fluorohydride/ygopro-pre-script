--無限起動ロードローラー
--scripted by Raye
function c101112022.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112022,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101112022)
	e1:SetCondition(c101112022.spcon)
	e1:SetTarget(c101112022.sptg)
	e1:SetOperation(c101112022.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
	--gain effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c101112022.matcheck)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_POSITION)
	e4:SetCondition(c101112022.poscon)
	e4:SetTarget(c101112022.postg)
	e4:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetValue(-1000)
	c:RegisterEffect(e5)
end
function c101112022.cfilter(c,tp)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH)
		and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c101112022.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101112022.cfilter,1,nil,tp)
end
function c101112022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101112022.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
function c101112022.matcheck(e)
	return e:GetHandler():GetOriginalRace()==RACE_MACHINE
end
function c101112022.poscon(e)
	return e:GetHandler():IsDefensePos()
end
function c101112022.postg(e,c)
	return c:IsFaceup()
end
