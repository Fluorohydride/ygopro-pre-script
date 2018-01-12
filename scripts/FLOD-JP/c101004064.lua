--にらみ合い
--Staredown
--Script by nekrozar
function c101004064.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101004064,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c101004064.mvcon1)
	e2:SetTarget(c101004064.mvtg1)
	e2:SetOperation(c101004064.mvop1)
	c:RegisterEffect(e2)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101004064,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c101004064.mvcon2)
	e3:SetTarget(c101004064.mvtg2)
	e3:SetOperation(c101004064.mvop2)
	c:RegisterEffect(e3)
end
function c101004064.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c101004064.mvcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101004064.cfilter,1,nil,tp)
end
function c101004064.mvfilter(c)
	return c:GetSequence()<5
end
function c101004064.mvtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=0
	local lg=eg:Filter(c101004064.cfilter,nil,tp)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,0,0,1-tp))
	end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c101004064.mvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101004064.mvfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL,zone)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101004064,2))
	Duel.SelectTarget(tp,c101004064.mvfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c101004064.mvop1(e,tp,eg,ep,ev,re,r,rp)
	local zone=0
	local lg=eg:Filter(c101004064.cfilter,nil,tp)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,0,0,1-tp))
	end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(tp)
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL,zone)<=0 then return end
	local flag=bit.bxor(zone,0xff)*0x10000
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,flag)/0x10000
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end
function c101004064.mvcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101004064.cfilter,1,nil,1-tp)
end
function c101004064.mvtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=0
	local lg=eg:Filter(c101004064.cfilter,nil,1-tp)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,0,0,tp))
	end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101004064.mvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101004064.mvfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL,zone)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101004064,2))
	Duel.SelectTarget(tp,c101004064.mvfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101004064.mvop2(e,tp,eg,ep,ev,re,r,rp)
	local zone=0
	local lg=eg:Filter(c101004064.cfilter,nil,1-tp)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,0,0,tp))
	end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp)
		or Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL,zone)<=0 then return end
	local flag=bit.bxor(zone,0xff)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end
