--サイバー・チュチュボン
--Cyber Tutubon
--Script by mercury233
function c100911010.initial_effect(c)
	--spsummon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c100911010.hspcon)
	e1:SetOperation(c100911010.hspop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCondition(c100911010.thcon)
	e2:SetTarget(c100911010.thtg)
	e2:SetOperation(c100911010.thop)
	c:RegisterEffect(e2)
end
function c100911010.hspfilter(c,tp)
	return c:IsRace(RACE_WARRIOR+RACE_FAIRY) and c:IsControler(tp)
end
function c100911010.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ct=0
	if Duel.CheckReleaseGroup(tp,c100911010.hspfilter,1,nil,tp) then ct=ct-1 end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>ct
		and Duel.CheckReleaseGroupEx(tp,Card.IsRace,1,e:GetHandler(),RACE_WARRIOR+RACE_FAIRY)
end
function c100911010.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		g=Duel.SelectReleaseGroupEx(tp,Card.IsRace,1,1,e:GetHandler(),RACE_WARRIOR+RACE_FAIRY)
	else
		g=Duel.SelectReleaseGroup(tp,c100911010.hspfilter,1,1,nil,tp)
	end
	Duel.Release(g,REASON_COST)
end
function c100911010.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_RITUAL)
end
function c100911010.thfilter(c)
	return c:GetType()==0x82 and c:IsAbleToHand()
end
function c100911010.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100911010.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100911010.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c100911010.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100911010.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
