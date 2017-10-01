--翠嵐の機界騎士
--Mekk-Knight of the Green Heights
--Scripted by Eerie Code
function c101003015.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101003015)
	e1:SetCondition(c101003015.hspcon)
	e1:SetValue(c101003015.hspval)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101003015,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101003015.thcon)
	e2:SetTarget(c101003015.thtg)
	e2:SetOperation(c101003015.thop)
	c:RegisterEffect(e2)
end
function c101003015.cfilter(c)
	return c:GetColumnGroupCount()>0
end
function c101003015.getzone(tp)
	local zone=0
	local lg=Duel.GetMatchingGroup(c101003015.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		if tc:IsControler(tp) then		
			zone=bit.bor(zone,bit.band(tc:GetColumnZone(LOCATION_MZONE),0xff))
		else
			zone=bit.bor(zone,bit.rshift(bit.band(tc:GetColumnZone(LOCATION_MZONE),0xff0000),16))
		end
	end
	return zone
end
function c101003015.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c101003015.getzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c101003015.hspval(e,c)
	local tp=c:GetControler()
	return 0,c101003015.getzone(tp)
end
function c101003015.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c) and tc and c:GetColumnGroup():IsContains(tc)
end
function c101003015.thfilter(c)
	return c:IsSetCard(0x20c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101003015.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101003015.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101003015.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101003015.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101003015.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
