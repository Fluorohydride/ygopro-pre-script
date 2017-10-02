--紺碧の機界騎士
--Jack Knight of the Azure Blue
--Scripted by Eerie Code
function c101003019.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101003019)
	e1:SetCondition(c101003019.hspcon)
	e1:SetValue(c101003019.hspval)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101003019,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c101003019.seqtg)
	e2:SetOperation(c101003019.seqop)
	c:RegisterEffect(e2)
end
function c101003019.cfilter(c)
	return c:GetColumnGroupCount()>0
end
function c101003019.getzone(tp)
	local zone=0
	local lg=Duel.GetMatchingGroup(c101003019.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		if tc:IsControler(tp) then
			zone=bit.bor(zone,bit.band(tc:GetColumnZone(LOCATION_MZONE),0xff))
		else
			zone=bit.bor(zone,bit.rshift(bit.band(tc:GetColumnZone(LOCATION_MZONE),0xff0000),16))
		end
	end
	return zone
end
function c101003019.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c101003019.getzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c101003019.hspval(e,c)
	local tp=c:GetControler()
	return 0,c101003019.getzone(tp)
end
function c101003019.seqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x20c)
end
function c101003019.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101003019.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101003019.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101003019,1))
	Duel.SelectTarget(tp,c101003019.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101003019.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,571)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end
