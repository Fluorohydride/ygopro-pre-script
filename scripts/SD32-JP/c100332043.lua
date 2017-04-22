--バイナル・ソーサレス
--Binal Sorceress
--Script by mercury233
function c100332043.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c100332043.matfilter,2,2)
	c:EnableReviveLimit()
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100332043,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c100332043.reccon)
	e1:SetTarget(c100332043.rectg)
	e1:SetOperation(c100332043.recop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100332043,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c100332043.atkcon)
	e2:SetTarget(c100332043.atktg)
	e2:SetOperation(c100332043.atkop)
	c:RegisterEffect(e2)
	--
	if not Card.GetMutualLinkedGroup then
		function aux.mutuallinkfilter(c,mc)
			local lg=c:GetLinkedGroup()
			return lg and lg:IsContains(mc)
		end
		function Card.GetMutualLinkedGroup(c)
			local lg=c:GetLinkedGroup()
			if not lg then return nil end
			return lg:Filter(aux.mutuallinkfilter,nil,c)
		end
		function Card.GetMutualLinkedCount(c)
			local lg=c:GetLinkedGroup()
			if not lg then return 0 end
			return lg:FilterCount(aux.mutuallinkfilter,nil,c)
		end
	end
end
function c100332043.matfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c100332043.reccon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetMutualLinkedGroup()
	local tc=eg:GetFirst()
	return ep~=tp and lg:IsContains(tc) and tc:GetBattleTarget()~=nil
end
function c100332043.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c100332043.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c100332043.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
		and e:GetHandler():GetMutualLinkedCount()>=2
end
function c100332043.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100332043,2))
	local g1=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100332043,3))
	local g2=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
end
function c100332043.atkop(e,tp,eg,ep,ev,re,r,rp)
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	if hc:IsFaceup() and hc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=hc:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(atk/2)
		if hc:RegisterEffect(e1) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e2:SetValue(atk/2)
			tc:RegisterEffect(e2)
		end
	end
end
