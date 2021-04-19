--氷河のアクア・マドール
--
--scripted by XyLeN
function c101105023.initial_effect(c)
	--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101105023,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101105023.indescon)
	e1:SetCost(c101105023.indescost)
	e1:SetTarget(c101105023.indestg)
	e1:SetOperation(c101105023.indesop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101105023,1))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCost(c101105023.descost)
	e2:SetTarget(c101105023.destg)
	e2:SetOperation(c101105023.desop)
	c:RegisterEffect(e2)
end
function c101105023.indescon(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(tp)
	e:SetLabelObject(a)
	return a and d and a:IsFaceup() and a:IsType(TYPE_NORMAL)
end
function c101105023.indescost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c101105023.indestg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c101105023.indesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=e:GetLabelObject()
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)>0 and a
		and a:IsRelateToBattle() and a:IsControler(tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		a:RegisterEffect(e1)
	end
end
function c101105023.cfilter(c)
	return c:IsType(TYPE_NORMAL) and not c:IsPublic()
end
function c101105023.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101105023.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101105023.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c101105023.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	e:SetLabelObject(tc)
	if chk==0 then return tc and tc:IsControler(1-tp) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c101105023.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)>0 then
		local tc=e:GetLabelObject()
		if tc and tc:IsRelateToBattle() and tc:IsControler(1-tp) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
