--Freki the Runick Fangs
--Scripted by: XGlitchy30

function c101110041.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x17f),2,true)
	--banish top deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110041,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101110041.rmcon)
	e1:SetTarget(c101110041.rmtg)
	e1:SetOperation(c101110041.rmop)
	c:RegisterEffect(e1)
	--no battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e2x=e2:Clone()
	e2x:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e2x)
	--add to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101110041,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,101110041)
	e3:SetCondition(c101110041.thcon)
	e3:SetTarget(c101110041.thtg)
	e3:SetOperation(c101110041.thop)
	c:RegisterEffect(e3)
end
function c101110041.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetSequence()>4
end
function c101110041.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetDecktopGroup(1-tp,2):FilterCount(Card.IsAbleToRemove,nil)==2 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,1-tp,LOCATION_DECK)
end
function c101110041.rmop(e,tp,eg,ep,ev,re,r,rp)
	local top=Duel.GetDecktopGroup(1-tp,2)
	if #top>0 then
		Duel.DisableShuffleCheck()
		Duel.Remove(top,POS_FACEUP,REASON_EFFECT)
	end
end

function c101110041.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c101110041.thfilter(c)
	return c:IsSetCard(0x17f) and c:GetType()&(TYPE_SPELL+TYPE_QUICKPLAY)==(TYPE_SPELL+TYPE_QUICKPLAY) and c:IsAbleToHand()
end
function c101110041.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101110041.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101110041.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101110041.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,tp,LOCATION_GRAVE)
end
function c101110041.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToChain(0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end