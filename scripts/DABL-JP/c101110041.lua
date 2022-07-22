--神碑の牙フレーキ
--Script by VHisc
function c101110041.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x17f),2,true)
	--remove
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
	--damage val
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101110041,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,101110041)
	e4:SetCondition(c101110041.thcon)
	e4:SetTarget(c101110041.thtg)
	e4:SetOperation(c101110041.thop)
	c:RegisterEffect(e4)
end
function c101110041.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
		and c:GetSequence()>4
end
function c101110041.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetDecktopGroup(1-tp,2):FilterCount(Card.IsAbleToRemove,nil)==2 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,1-tp,LOCATION_DECK)
end
function c101110041.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,2)
	if #g>0 then
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c101110041.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c101110041.thfilter(c)
	return c:IsSetCard(0x17f) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
end
function c101110041.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101110041.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101110041.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101110041.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101110041.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
