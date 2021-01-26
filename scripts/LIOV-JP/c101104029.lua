--ヤモイモリ
--Yamoimori
--Scripted by Kohana Sonogami
function c101104029.initial_effect(c)
	--change / destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,101104029)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c101104029.target)
	e1:SetOperation(c101104029.activate)
	c:RegisterEffect(e1)
end
function c101104029.filter1(c)
	return c:IsFaceup() and c:IsRace(RACE_REPTILE)
end
function c101104029.filter2(c)
	return c:IsFaceup() and (c:IsCanTurnSet() or c:GetAttack()>0)
end
function c101104029.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101104029.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c101104029.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c101104029.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c101104029.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	local sel
	local tc2=g2:GetFirst()
	if tc2:IsAttack(0) then
		sel=Duel.SelectOption(tp,aux.Stringid(101104029,0))
	elseif not tc2:IsCanTurnSet() then
		sel=Duel.SelectOption(tp,aux.Stringid(101104029,1))+1
	else
		sel=Duel.SelectOption(tp,aux.Stringid(101104029,0),aux.Stringid(101104029,1))
	end
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(CATEGORY_POSITION)
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g1,1,0,0)
	else
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	end
end
function c101104029.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sel=e:GetLabel()
	if sel==0 then
		local tg=g:Filter(Card.IsRelateToEffect,nil,e)
		Duel.ChangePosition(tg,POS_FACEDOWN_DEFENSE)
	else
		local tc1=e:GetLabelObject()
		local tc2=g:GetFirst()
		if tc2==tc1 then tc2=g:GetNext() end
		if tc1:IsRelateToEffect(e) and Duel.Destroy(tc1,REASON_EFFECT)~=0 and tc2:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(tc2)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc2:RegisterEffect(e1)
		end
	end
end
