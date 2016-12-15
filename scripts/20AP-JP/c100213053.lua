--シューティング・ソニック
--Cosmic Flare
--Scripted by Eerie Code
--The Tribute replacement has been hardcoded into the 2 "Stardust" monsters
function c100213053.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c100213053.target)
	e1:SetOperation(c100213053.activate)
	c:RegisterEffect(e1)
end
function c100213053.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa3) and c:IsType(TYPE_SYNCHRO)
end
function c100213053.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100213053.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100213053.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100213053.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100213053.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		--return to hand
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(100213053,1))
		e1:SetCategory(CATEGORY_TOHAND)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_BATTLE_START)
		e1:SetTarget(c100213053.tdtg)
		e1:SetOperation(c100213053.tdop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c100213053.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
end
function c100213053.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc and tc==c then tc=Duel.GetAttackTarget() end
	if tc and tc:IsRelateToBattle() then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
