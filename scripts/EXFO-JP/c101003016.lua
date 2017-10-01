--燈影の機界騎士
--Mekk-Knight of the Flickering Flame
--Scripted by Eerie Code
function c101003016.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101003016)
	e1:SetCondition(c101003016.hspcon)
	e1:SetValue(c101003016.hspval)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101003016,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c101003016.spcon)
	e2:SetTarget(c101003016.sptg)
	e2:SetOperation(c101003016.spop)
	c:RegisterEffect(e2)
end
function c101003016.cfilter(c)
	return c:GetColumnGroupCount()>0
end
function c101003016.getzone(tp)
	local zone=0
	local lg=Duel.GetMatchingGroup(c101003016.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		if tc:IsControler(tp) then
			zone=bit.bor(zone,bit.band(tc:GetColumnZone(LOCATION_MZONE),0xff))
		else
			zone=bit.bor(zone,bit.rshift(bit.band(tc:GetColumnZone(LOCATION_MZONE),0xff0000),16))
		end
	end
	return zone
end
function c101003016.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c101003016.getzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c101003016.hspval(e,c)
	local tp=c:GetControler()
	return 0,c101003016.getzone(tp)
end
function c101003016.spcfilter(c,tp,mc)
	if c:GetPreviousControler()==tp then return false end
	local loc=LOCATION_MZONE
	if c:IsPreviousLocation(LOCATION_SZONE) then loc=LOCATION_SZONE end
	local zone=mc:GetColumnZone(loc)
	local seq=c:GetPreviousSequence()+16
	return zone and bit.extract(zone,seq)~=0
end
function c101003016.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101003016.spcfilter,1,nil,tp,e:GetHandler())
end
function c101003016.filter(c,e,tp)
	return c:IsSetCard(0x20c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101003016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101003016.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101003016.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101003016.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
