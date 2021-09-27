--攻撃誘導アーマー
--
--Script by Trishula9
function c100284001.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,100284001+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100284001.target)
	e1:SetOperation(c100284001.operation)
	c:RegisterEffect(e1)
end
function c100284001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local a,d=Duel.GetBattleMonster(0)
	local ad=Group.FromCards(a,d)
	local s=0
	local b=Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,ad)
	if b then
		s=Duel.SelectOption(tp,aux.Stringid(100284001,0),aux.Stringid(100284001,1))
	end
	e:SetLabel(s)
	if s==0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,a,1,0,0)
	end
	if s==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,ad)
	end
end
function c100284001.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if e:GetLabel()==0 then
		if a and a:IsRelateToBattle() then
			Duel.Destroy(a,REASON_EFFECT)
		end
	end
	if e:GetLabel()==1 then
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) and a:IsAttackable() and not a:IsImmuneToEffect(e) then
			Duel.CalculateDamage(a,tc)
		end
	end
end